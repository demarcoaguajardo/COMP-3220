with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

package body Assgn is
   --1) initialize first array (My_Array) with random binary values
   procedure Init_Array (Arr: in out BINARY_ARRAY) is
        Seed : Ada.Numerics.Float_Random.Generator;
   begin
        for I in Arr'Range loop
            -- If the random is less than 0.5, then bit is 0.
            if Random(Seed) < 0.5 then
                Arr(I) := 0;
            else
            -- 1 otherwise.
                Arr(I) := 1;
            end if;
        end loop;
    end Init_Array;

    --2) reverse binary array
   procedure Reverse_Bin_Arr (Arr : in out BINARY_ARRAY) is
        TempNum : BINARY_NUMBER;
   begin 
        -- Loop over the first half of the array
        for I in 1..Arr'Length / 2 loop
            -- Swap temp current element with a corresponding last element
            TempNum := Arr(I);
            Arr(I) := Arr(Arr'Length - I + 1);
            Arr(Arr'Last - I + 1) := TempNum;
        end loop;
    end Reverse_Bin_Arr;

   --3) Implement the procedure to print an array
   procedure Print_Bin_Arr (Arr : in BINARY_ARRAY) is
   begin
      -- Loop each element
      for I in Arr'Range loop
         -- Print the element
         Put(Item => Integer'Image(Arr(I)));
      end loop;
      -- Print a new line
      New_Line;
   end Print_Bin_Arr;

   --4) Convert Integer to Binary Array
   function Int_To_Bin(Num : in INTEGER) return BINARY_ARRAY is
        -- Initialize the array with 0s
        Result : BINARY_ARRAY := (others => 0); 
        -- Temporary variable to store the number
        TempNum : INTEGER := Num;
        -- Start from last index
        Index : INTEGER := Result'Last;
   begin
        -- While # > 0
        while TempNum > 0 loop
            -- Get remainder of #/2 (binary digit)
            Result(Index) := TempNum mod 2;
            -- Divide the number by 2
            TempNum := TempNum / 2;
            -- Move to the next index
            Index := Index - 1;
        end loop;

        -- Return the result
        return Result;
   end Int_To_Bin;

   --5) Convert Binary Array to Integer
   function Bin_To_Int(Arr : in BINARY_ARRAY) return INTEGER is
        -- Initialize the result
        Result : INTEGER := 0;
    begin
        -- Loop each element
        for I in Arr'Range loop
            -- Add the bit value times 2 to the power of its position
            Result := Result + Arr(I) * 2**(Arr'Last - I);
        end loop;

        -- Return the result
        return Result;
    end Bin_To_Int;

    --6) overloaded + operator to add an INTEGER type and a BINARY_ARRAY type together
    function "+" (Left : in INTEGER;
                Right : in BINARY_ARRAY) return BINARY_ARRAY is
        -- Convert integer to binary array
        LeftArr : BINARY_ARRAY := Int_To_Bin(Left);
        -- Initialize result array with 0s
        Result : BINARY_ARRAY := (others => 0);
        -- Variable to store the carry
        Carry : Integer := 0;
        -- Overflow exception
        Overflow : exception;
    begin
        -- Loop from last index to the first
        for I in reverse LeftArr'Range loop
            -- Calculate the sum of the current bits and the carry
            declare
                Sum : Integer := LeftArr(I) + Right(I) + Carry;
            begin
                -- The result bit is the sum module 2
                Result(I) := Sum mod 2;
                -- The carry is the sum divided by 2
                Carry := Sum / 2;
            end;
        end loop;

        -- If there is still a carry, raise overflow exception
        if Carry = 1 then
            raise Overflow;
        end if;

        -- Return the result
        return Result;
    end "+";

    --7) overloaded + operator to add two BINARY_ARRAY types together
    function "+" (Left, Right : in BINARY_ARRAY) return BINARY_ARRAY is
        -- Initialize the result array with 0s
        Result : BINARY_ARRAY := (others => 0);
        -- Variable to store the carry
        Carry : Integer := 0;
    begin
        -- Loop from last index to first
        for I in reverse Left'Range loop
            -- Calculate the sum of the current bits and the carry
            declare
                Sum : Integer := Left(I) + Right(I) + Carry;
            begin
                -- The result bit is the sum module 2
                Result(I) := Sum mod 2;
                -- The carry is the sum divided by 2
                Carry := Sum / 2;
            end;
        end loop;

        -- If there is still a carry, raise overflow exception
        if Carry = 1 then
            raise Overflow;
        end if;

        -- Return the result
        return Result;
    end "+";

    --8) overloaded - operator to subtract one BINARY_ARRAY type from another
    function "-" (Left, Right : in BINARY_ARRAY) return BINARY_ARRAY is
        -- Initialize the result array with 0s
        Result : BINARY_ARRAY := (others => 0);
        -- Variable to store the borrow
        Borrow : Integer := 0;
    begin
        -- Loop from last index to first
        for I in reverse Left'Range loop
            -- Calculate the difference of the current bits and the borrow
            if Left(I) - Borrow >= Right(I) then
                Result(I) := Left(I) - Right(I) - Borrow;
                Borrow := 0;
            else
                Result(I) := Left(I) + 2 - Right(I) - Borrow;
                Borrow := 1;
            end if;
        end loop;

        -- If there is still a borrow, raise underflow exception
        if Borrow = 1 then
            raise Constraint_Error;
        end if;

        -- Return the result
        return Result;
    end "-";

    --8) overloaded - operator to subtract a BINARY_ARRAY type from an INTEGER type
    function "-" (Left : in Integer; Right : in BINARY_ARRAY) return BINARY_ARRAY is
        -- Convert integer to binary array
        LeftArr : BINARY_ARRAY := Int_To_Bin(Left);
    begin
        -- Use the other overloaded - operator
        return LeftArr - Right;
     end "-";

end Assgn;